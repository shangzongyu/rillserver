### 1.上传脚本说明

上传脚本是用脚本来打包项目文件并上传到服务器上，也可以根据自己的需求来只是上传或是上传且自动重启服务器
这样一来步骤就变更具效率及省心，使用也非常简单，只需`bash release/relase.sh copy|deploy`然后选择服务器


### 2.外部软件安装

外部软件安装同样是为了提高效率及使用简便，用脚本来完成人工需要的工作，大大减轻了人为的工作。这里我们在10.10.2.54上
有一个3rd-soft的仓库，以后外部需要的软件安装包或工具都可以放到此仓库下，这里暂时包含nginx和php两个源码的目录并加上
了自已经用于部署的`sudo.sh``install.sh`的自定义脚本

#### 2.1安装使用说明

- `bash release/install filepath`  **filepath**是指我们需要安装的软件源码包`nginx-1.8.0.tar.gz`最好是以仓库里面的文件名为标准，否则得自行修改运行时出现的问题
-  执行脚本选择好服务器后会自行解压进行安装，nginx默认监听的端口是80，php默认监听的端口是9000如有需要自行修改
-  documentroot默认是上传服务器所在目录的www目录下面

### 3. 程序启动

- 默认执行install.sh后，会在安装的目录如:`/data/nginx1.8.0`目录下面有`start.sh stop.sh restart.sh`用于启停服务的脚本，由于nginx默认监听的80端口需要root权限，如需非root要大于1024以上的端口