<!-- 该文档是模板生成，手动修改的内容会被覆盖，详情参见：https://github.com/quicklyon/template-toolkit -->
# QuickOn next-terminal 应用镜像

![GitHub Workflow Status (event)](https://img.shields.io/github/workflow/status/quicklyon/next-terminal-docker/build?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/easysoft/next-terminal?style=flat-square)
![Docker Image Size](https://img.shields.io/docker/image-size/easysoft/next-terminal?style=flat-square)
![GitHub tag](https://img.shields.io/github/v/tag/quicklyon/next-terminal-docker?style=flat-square)

> 申明: 该软件镜像是由QuickOn打包。在发行中提及的各自商标由各自的公司或个人所有，使用它们并不意味着任何从属关系。

## 快速参考

- 通过 [渠成软件百宝箱](https://www.qucheng.com/app-install/install-next-terminal-135.html) 一键安装 **next-terminal**
- [Dockerfile 源码](https://github.com/quicklyon/next-terminal-docker)
- [next-terminal 源码](https://github.com/dushixiang/next-terminal)
- [next-terminal 官网](https://github.com/dushixiang/next-terminal)

## 一、关于 next-terminal

[Next Terminal](https://github.com/dushixiang/next-terminal)是使用Golang和React开发的一款HTML5的远程桌面网关，具有小巧、易安装、易使用、资源占用小的特点，支持RDP、SSH、VNC和Telnet协议的连接和管理。

![screenshots](https://raw.githubusercontent.com/quicklyon/next-terminal-docker/main/.template/screenshot.png)

next-terminal官网：[https://github.com/dushixiang/next-terminal](https://github.com/dushixiang/next-terminal)

### 1.1 功能

- 授权凭证管理
- 资产管理（支持RDP、SSH、VNC、TELNET协议）
- 指令管理
- 批量执行命令
- 在线会话管理（监控、强制断开）
- 离线会话管理（查看录屏）
- 双因素认证
- 资产标签
- 资产授权
- 多用户&用户分组
- 计划任务
- 开源免费

## 二、支持的版本(Tag)

由于版本比较多,这里只列出最新的5个版本,更详细的版本列表请参考:[可用版本列表](https://hub.docker.com/r/easysoft/next-terminal/tags/)

<!-- 这里是应用的【Tag】信息，通过命令维护，详情参考：https://github.com/quicklyon/template-toolkit -->
- [latest](https://github.com/dushixiang/next-terminal/tags)
- [1.2.7](https://github.com/dushixiang/next-terminal/releases/tag/v1.2.7)

## 三、获取镜像

推荐从 [Docker Hub Registry](https://hub.docker.com/r/easysoft/next-terminal) 拉取我们构建好的官方Docker镜像。

```bash
docker pull easysoft/next-terminal:latest
```

如需使用指定的版本,可以拉取一个包含版本标签的镜像,在Docker Hub仓库中查看 [可用版本列表](https://hub.docker.com/r/easysoft/next-terminal/tags/)

```bash
docker pull easysoft/next-terminal:[TAG]
```

## 四、持久化数据

如果你删除容器，所有的数据都将被删除，下次运行镜像时会重新初始化数据。为了避免数据丢失，你应该为容器提供一个挂在卷，这样可以将数据进行持久化存储。

为了数据持久化，你应该挂载持久化目录：

- /usr/local/next-terminal/data 持久化数据

如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
$ docker run -it \
    -v $PWD/data:/usr/local/next-terminal/data \
docker pull easysoft/next-terminal:latest
```

或者修改 docker-compose.yml 文件，添加持久化目录配置

```bash
services:
  next-terminal:
  ...
    volumes:
      - /path/to/persistence:/usr/local/next-terminal/data
  ...
```

## 五、环境变量

| 变量名           | 默认值        | 说明                             |
| ---------------- | ------------- | -------------------------------- |
| EASYSOFT_DEBUG   | false         | 是否打开调试信息，默认关闭       |
| MYSQL_HOSTNAME   | 127.0.0.1     | MySQL 主机地址                   |
| MYSQL_PORT       | 3306          | MySQL 端口                       |
| MYSQL_DATABASE   | next-terminal | next-terminal  数据库名称                 |
| MYSQL_USER       | next-terminal | MySQL 用户名                      |
| MYSQL_PASSWORD   | next-terminal | MySQL 密码                        |
| GUACD_HOSTNAME   | 127.0.0.1     | Guacd 服务地址 |
| GUACD_PORT       | 4822          | Guacd 端口 |

## 六、运行

### 6.1 单机Docker-compose方式运行

```bash
# 启动服务
make run

# 查看服务状态
make ps

# 查看服务日志
docker-compose logs -f next-terminal

```

**说明:**

- 启动成功后，打开浏览器输入 `http://<你的IP>:8088` 访问管理后台
- 默认用户名：`admin`，默认密码：`admin`
- [VERSION](https://github.com/quicklyon/next-terminal-docker/blob/main/VERSION) 文件中详细的定义了Makefile可以操作的版本
- [docker-compose.yml](https://github.com/quicklyon/next-terminal-docker/blob/main/docker-compose.yml)
