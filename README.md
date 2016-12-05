## Ansible playbook ポリシー
- 原則として汎用性の観点から実行する際にタグ指定 (--tags or -t) および ホスト限定 (--limit or -l) を前提とする
    * 前後の同じタグの実行順序を加味して各タスクにはタグの指定をする
    * `./playbooks/setup.yml` にタグ付はしない
    * `./playbooks/setup.yml` の `hosts` は `all` (すべてのホストに対して実行) とする

## ホスト構成
| hostname | ip addr | distro | (接続モード) connection mode | インベントリグループ |
| --- | --- | --- | --- | --- |
| local-dev | localhost | | local | local-dev |
| neec.xyz | 133.130.117.111 | Ubuntu 16.04 LTS | ssh (smart) | neeco, neec.xyz |
| neec.ooo | 163.44.166.216 | CentOS 7.2 | ssh (smart) | neeco, neec.ooo |
| neec.bid | 133.130.119.187 | Debian GNU/Linux 8.5 | ssh (smart) | neeco, neec.bid |

## セットアップ
Ansible のインストール (バージョン管理の観点から pip 経由)
```sh
make install-ansible
```

次のように `PARAM` 変数に対して ansible-playbook コマンドにおける任意のオプションを設定 (ref: `ansible-playbook --help`)
```sh
PARAM="-t common:setup" make play # すべてのホストに対して common:setup タグの付いたタスクを実行
PARAM="-l neec.xyz -t docker:engine" make play # neec.xyz インベントリに限定 (limit) して docker:engine タグの付いたタスクを実行
PARAM="-l neeco -t dokcer:engine" make play # neeco インベントリグループ (neec.xyz, neec.ooo) に限定して docker:engine タグの付いたタスクを実行
```

### 使用可能なタグ (`--tags or -t`)
| key | 役割 | バージョンの指定 | メモ |
| --- | --- | --- | --- |
| `common:setup` | *install* common pkgs | 可 | |
| `common:hostname` | *configure* hostname | n/a | |
| `docker:engine` | *install* docker engine | 可 | |
| `docker:compose` | *install* docker compose | 可 | |
| `docker:daemon` | *configure* docker daemon | n/a | |
| `rancher:server` | *install* rancher server | 可 | |
| `rancher:agent` | *install* rancher agent | 可 | |
| `rancher:compose` | *install* rancher compose | 可 | |
| `rancher:cli` | *install* rancher cli | 可 | |
| `firewall:setup` | *configure* firewall | n/a | Ubuntu: `ufw`, CentOS 7: `firewalld` |

### バージョンの管理 (`--extra-vars or -e`)
| key | 既定値 | 関連するタグ | メモ |
| --- | --- | --- | --- |
| `docker_builds_selected` | *main* | `docker:engine` | *`main`, `testing`, `experimental`* |
| `docker_engine_version` | *1.12.3* | `docker:engine` | |
| `docker_compose_version` | *1.9.0* | `docker:compose` | |
| `rancher_server_version` | *1.2.0* | `rancher:server` | |
| `rancher_server_expose_port` | *8080* | `rancher:server` `rancher:agent` | |
| `rancher_api_version` | *v2-beta* | `rancher:agent` | *v1*, *v2-beta* |
| `rancher_agent_version` | *自動的に racher server 経由で取得* | `rancher:agent` | |
| `rancher_compose_version` | *0.9.2* | `rancher:compose` | |
| `rancher_cli_version` | *0.4.0* | `rancher:cli` | |

## neec.* への実行例
### neec.xyz
~~~sh
PARAM="-l neec.xyz -t common:setup,common:hostname,docker:engine,docker:compose --private-key=/please/fullpath/secret.key" sudo -E make play
~~~

## 実行確認済 distro
- CentOS 7.2
- Ubuntu 16.04 LTS
- Ubuntu 14.04 LTS
- Debian GNU/Linux 8.5