# java.net.SocketException四大异常解决方案



### <span style="padding: 0px; margin: 0px; line-height: 28px; font-size: 21px; font-family: 宋体;">一.异常1 java.net.BindException:Address already in use: JVM\_Bind</span> 

<span style="padding: 0px; margin: 0px; font-family: 微软雅黑, Verdana, sans-serif, 宋体;">      该异常发生在服务器端进行new ServerSocket(port)（port是一个0，65536的整型值）操作时。异常的原因是以为与port一样的一个端口已经被启动，并进行监听。此时用netstat –an命令，可以看到一个Listending状态的端口。只需要找一个没有被占用的端口就能解决这个问题。</span>



### <span style="padding: 0px; margin: 0px; line-height: 28px; font-size: 21px; font-family: 宋体;">二.异常2 java.net.SocketException: Connection refused: connect</span> 

<span style="padding: 0px; margin: 0px; font-family: 微软雅黑, Verdana, sans-serif, 宋体;">      该异常发生在客户端进行 new Socket(ip, port)操作时，该异常发生的原因是或者具有ip地址的机器不能找到（也就是说从当前机器不存在到指定ip路由），或者是该ip存在，但找不到指定的端口进行监听。出现该问题，首先检查客户端的ip和port是否写错了，如果正确则从客户端ping一下服务器看是否能ping通，如果能ping通（服务服务器端把ping禁掉则需要另外的办法），则看在服务器端的监听指定端口的程序是否启动，这个肯定能解决这个问题。</span>



### <span style="padding: 0px; margin: 0px; line-height: 28px; font-size: 21px; font-family: 宋体;">三.异常3 java.net.SocketException: Socket is closed</span> 

<span style="padding: 0px; margin: 0px; font-family: 微软雅黑, Verdana, sans-serif, 宋体;">      该异常在客户端和服务器均可能发生。异常的原因是己方主动关闭了连接后（调用了Socket的close方法）再对网络连接进行读写操作。</span>



### <span style="padding: 0px; margin: 0px; line-height: 28px; font-size: 21px; font-family: 宋体;">四.异常4 java.net.SocketException: （Connection reset或者Connect reset by peer:Socket write error）</span> 

<span style="padding: 0px; margin: 0px; font-family: 微软雅黑, Verdana, sans-serif, 宋体;">      该异常在客户端和服务器端均有可能发生，引起该异常的原因有两个，第一个就是如果一端的Socket被关闭（或主动关闭或者因为异常退出而引起的关闭），另一端仍发送数据，发送的第一个数据包引发该异常(Connect reset by peer)。另一个是一端退出，但退出时并未关闭该连接，另一端如果在从连接中读数据则抛出该异常（Connection reset）。简单的说就是在连接断开后的读和写操作引起的。</span>



### <span style="padding: 0px; margin: 0px; line-height: 28px; font-size: 21px; font-family: 宋体;">五.异常5 java.net.SocketException: Broken pipe</span> 

<span style="padding: 0px; margin: 0px; font-family: 微软雅黑, Verdana, sans-serif, 宋体;">      该异常在客户端和服务器均有可能发生。在第4个异常的第一种情况中（也就是抛出 SocketExcepton:Connect reset by peer:Socket write error后），如果再继续写数据则抛出该异常。前两个异常的解决方法是首先确保程序退出前关闭所有的网络连接，其次是要检测对方的关闭连接操作，发现对方关闭连接后自己也要关闭该连接。</span>

> java.net.SocketException: Broken pipe at java.net.SocketOutputStream.socketWrite0(Native Method) 一般出现在linux服务器上，常常由于网络不稳定或者服务器负荷过大，管道读端没有在读，而管道的写端继续有线程在写，就会造成管道中断。（由于管道是单向通信的） SIGSEGV(Segment fault)意味着指针所对应的地址是无效地址，没有物理内存对应该地址。 
>
> 以下是UNIX的信号解释：
>
> > 11 / SIGSEGV: Unerlaubter Zugriff auf Hauptspeicher (Adressfehler).
> >
> > 12 / SIGUSER2: User-defined Signal 2 (POSIX). 把\_JAVA\_SR\_SIGNUM改成12只是将信号至成user-defined，让它不报出来而已，不能解决问题。

> 建议采取的方式：
>
> 1. 资源没有完全释放，用完后要至NULL 值（JAVA的GC没那么完善） 
> 2. 数据库连接顺序关闭！（RS，PS，CONN） 
> 3. 优化JAVA虚拟机 加入相应的内存参数！ 
> 4. 不要在数据库中获取大段文本（即一个栏位的值不要太大） 
> 5.  JAVA 不推荐 用String 获取大量信息。（容易造成内存泄露，建议用StringBuffer）
> 6. 页面重复提交 
> 7. 尽量将METHOD移到JAVA中，在JSP中所有的方法都看做全局变量，编译执行本身就有很多问题。 
> 8. 如果是查询功能，尽可能的使用非XA(事务)。 
> 9. 尽量用较新较稳定版本的JDK，低版本的JVM本身也有很多BUG，比如1。5的垃圾回收比起1。2，1。3一定是非常明显的进步。
> 10. LINUX系统本身没有这么稳定，有些问题无法避免的~~：）



### <span style="padding: 0px; margin: 0px; line-height: 28px; font-size: 21px; font-family: 宋体;">六.编写网络程序时需要注意的问题</span> 

       第1个问题是要正确区分长、短连接。所谓的长连接是一经建立就永久保持。短连接就是在以下场景下，准备数据—&gt;建立连接— &gt;发送数据—&gt;关闭连接。很多的程序员写了多年的网络程序，居然不知道什么是长连接，什么是短连接。

      第2个问题是对长连接的维护。所谓的维护包括两个方面，首先是检测对方的主动断连（既调用 Socket的close方法），其次是检测对方的宕机、异常退出及网络不通。这是一个健壮的通信程序必须具备的。检测对方的主动断连很简单，主要一方主动断连，另一方如果在进行读操作，则此时的返回值只-1，一旦检测到对方断连，则应该主动关闭己方的连接（调用Socket的close方法）。

      而检测对方的宕机、异常退出及网络不通常用方法是用“心跳”，也就是双方周期性的发送数据给对方，同时也从对方接收“心跳”，如果连续几个周期都没有收到对方心跳，则可以判断对方或者宕机或者异常推出或者网络不通，此时也需要主动关闭己方连接，如果是客户端可在延迟一定时间后重新发起连接。虽然Socket有一个keep alive选项来维护连接，如果用该选项，一般需要两个小时才能发现对方的宕机、异常退出及网络不通。

      第3个问题是处理效率问题。不管是客户端还是服务器，如果是长连接一个程序至少需要两个线程，一个用于接收数据，一个用于发送心跳，写数据不需要专门的线程，当然另外还需要一类线程（俗称Worker线程）用于进行消息的处理，也就是说接收线程仅仅负责接收数据，然后再分发给Worker进行数据的处理。如果是短连接，则不需要发送心跳的线程，如果是服务器还需要一个专门的线程负责进行连接请求的监听。这些是一个通信程序的整体要求，具体怎么设计你的程序，就看你自己的设计水平了。


