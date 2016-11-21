检查Selinux状态

#sestatus

如果输出不为 SELinux status:    disabled .可以昨时先关闭 .命令如下：

#setenforce 0

永久关闭方法：

#vim  /etc/sysconfig/selinux  把SELINUX=disabled 并重启系统