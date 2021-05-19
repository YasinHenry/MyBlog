- 创建内部虚拟交换机
`New-VMSwitch -SwitchName "Hadoop" -SwitchType Internal`

- 查看内部交换机的索引# 名称类似于 vEthernet (SwitchName)
`Get-NetAdapter`

- 创建nat网关
  `New-NetIPAddress -IPAddress <NAT Gateway IP> -PrefixLength <NAT Subnet Prefix Length> -InterfaceIndex <ifIndex>`

  eg:`New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex 24`

- 配置Nat网络
  `New-NetNat -Name <NATOutsideName> -InternalIPInterfaceAddressPrefix <NAT subnet prefix>`