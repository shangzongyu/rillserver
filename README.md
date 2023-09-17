# 说在前面的话

1. 该框架并非本人设计 详细设计思路可以探讨也可以咨询原作者 链接：https://github.com/cloudfreexiao/RillServer
2. 在原版本基础上修改如下几点：
  1. 完成运行问题的修复，保证基础 demo 能跑通
  2. 测试 mysql 数据库的使用
  3. 修改用户快速登录问题
  4. 修改 room 创建模式，改为 lua service pool 模式，仿照 agent pool 修改
  5. 框架细微调整

# RillServer

RillServer 是一套基于 skynet 的通用游戏服务端框架，适合大作战、棋牌、RPG、策略等多种类型的游戏服务器。设计初衷是为了极大的提高开发效率，减少游戏开发成本。

总要取个名字，Rill 小河，喻意服务畅通无阻，亦表积流成海。假以时日，厚积薄发。

## 整体架构

RillServer 采用传统 C++ 服务器的架构方案。服务为 1:1 对应(agent room)

### 架构图

整体架构如下图所示，蓝色方框代表 skynet 节点，黄色方框代表服务，一个节点会开启 game、global、login 等多种服务。灰色方框代表 gateway 的转发范围，即客户端连上某个节点的 gateway，该 gateway 只会将消息转发给该节点下的 login 和 game。

![Alt text](./doc/img/1.jpg)

### 各个服务的功能

- gateway：网关，客户端只连接 gateway，如果玩家尚未登录，gateway 会把消息发给 login，如果登录成功会转发给 game
- login：登录服，处理登录逻辑
- game：游戏服，处理玩家逻辑
- center：中心服，记录玩家登录状态等信息
- global: 全局服，可在此实现跨服战等功能
- dbproxy：数据库代理，使用服务不直接操作数据库，只操作 dbproxy
- host：主机，用于集群控制，如热更新、关服，以及 web
  > PS：
  > 1、一个节点的 gate 只会连接该节点的 login 和 game，login 和 game 可以连接跨节点的 center、global 和 dbproxy。
  > 2、暂时未实现 cache 层。
  > 3、框架尽量不修改 skynet 代码，以便后续升级，但有些功能需要插入到原来代码里，升级时候务必修改这一部分。这些修改不会涉及核心部分，一般是增加控制台功能。若升级 skynet，应该把这一部分抽出来。
  > skynet/lualib/debug.lua
  > skynet/service/debug_console.lua
  > skynet/service/launcher.lua

### 文件目录

- config：策划配置文件夹
- etc：服务配置文件夹
- luaclib：一些 C 模块, .so 文件
- lualib：lua 模块
- lualib-src：C 模块代码
- mod：游戏逻辑模块
- proto：protobuf 文件，若使用 pb 协议需要把 proto 文件放在里面
- run：记录 pid 等信息
- service：服务入口地址，服务开启后会读取 mod 里对应模块
- skynet：skynet 框架，这里尽量少改动它，以便后续更新
- test：例子

## 入门

入门章节将会介绍开启服务器以及实现 echo 程序，若还不太熟悉 skynet 和服务端编程，欢迎参考 [游戏研究院](https://zhuanlan.zhihu.com/pyluo) 中的文章。

### 编译

下载代码后需要编程程序，只需要运行目录下的./make.sh all 即可。服务端默认使用 websocket+json 的通信协议。

**protobuf 协议** 只要改配置就能够支持 tcp（头两字节代表长度）+protobuf 的格式。 服务端使用 LuaPbIntf 解析 protobuf 协议，如果使用 protobuf 协议，需要安装 protobuf，具体如下：

```sh
yum nstall autoconf
yum install automake
yum install libtool
yum install glibc-headers gcc-c++
cd lualib-src/LuaPbIntf/third_party/protobuf
./autogen.sh
./configure CFLAGS="-fPIC" CXXFLAGS="-fPIC"
make
make install
vim /etc/profile，添加 LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
ldconfig
```

源码中对 LuaPbIntf 稍有改动，以适应协程下的 protobuf 编码解码

### 运行

修改 `etc/runconfig.lua` 中的端口号，然后执行./start.sh 即可开启一个游戏节点。

### echo

具体请参考示例 1

---

## 示例

- 示例 1 echo
  服务端./start_node1.sh 即可运行服务端（单阶段）
  客户端 cd test ../skynet/3rd/lua/lua 1-echo.lua
- 示例 2 name  
   数据库保存测试
- 示例 3 chat
- 示例 4 movegame
- 示例 5 读配置
- 示例 6 日志
- 示例 7 代码热更新，配置热更新
- 示例 8 排行榜
  排行榜查询次数的排行榜，演示 global 保存数据
- 示例 9 数据库断线重连
  使用示例 1 登录，关闭数据库，测试，重开数据库，测试
- 示例 10 关服功能
- 示例 11 pb 协议
- 示例 12 xx 大作战

---

## 可以改进

- [优化] 监视功能
- [测试] 性能测试
- [优化] game 改成 agentpool 那样的，按需开启
- [优化] 玩家存储：加一层 redis
- [必须] web 鉴权
- [必须] 未测试 mongodb 修改成 mysqldb 的形式。
- [优化] web 单独提取
- [优化] 提取修改 skynet 的部分，不要修改 skynet 所有源码
- [优化] log 功能
- [优化] 同一账号快速登录会出现问题
- [bug] watch game 列表，recmmad 列表（可能出错）
- [bug] 大作战高并发下，不发送 sync 协议

## 已经发现的注意点

bson：bson 会把 key 都存为 string，读取时要 tonumber 处理
由于 dataSheet 在 init 阶段初始化，而 awake、start 在 init 阶段前执行，修改 skynet/lualib/skynet/datasheet/init.lua 的 querysheet 函数，增加 if datasheet_svr == nil then datasheet_svr = service.query("datasheet") end

内网改的
tool 增加表拷贝
将 player 相关的都放到 player 文件夹（new load_data load_all_data save_all_data），改为读取 pb 结构保存{playerid,pbstr}
