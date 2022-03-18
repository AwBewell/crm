package com.bjpowernode.crm.settings;

import com.bjpowernode.crm.utils.DateTimeUtil;
import org.junit.Test;

public class TesT1 {
    @Test
    public void testLogin(){
       /* //验证时间
        String expireTime = "2021-10-10 10:10:10";
        String currentTime = DateTimeUtil.getSysTime();
        int count = expireTime.compareTo(currentTime);
        System.out.println(count);*/
       /* //验证锁定状态
        String lockState = "0";
        if("0".equals(lockState)){
            System.out.println("已经被锁定了");
        }*/
        //浏览器的IP地址
        String ip = "192.168.1.1";
        String allowIps = "192.168.1.1,192.168.1.2";
        if(allowIps.contains(ip)){
            System.out.println("有效的ip地址，允许访问系统");
        }else if(allowIps.contains(ip)){
            System.out.println("ip地址受限，请联系管理员");
        }
    }
}
