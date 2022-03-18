package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.bjpowernode.crm.workbench.service.impl.ClueServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到线索控制器");

        String path = request.getServletPath();
        if ("/workbench/clue/getUserList.do".equals(path)){
            getUserList(request,response);

        }else if ("/workbench/clue/save.do".equals(path)){
            save(request,response);
        }

    }

    private void save(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行添加的操作");
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
            String id = UUIDUtil.getUUID();
            String fullname = request.getParameter("fullname");
            String appellation = request.getParameter("appellation");
            String owner = request.getParameter("owner");
            String company = request.getParameter("company");
            String job = request.getParameter("job");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String website = request.getParameter("website");
            String mphone = request.getParameter("mphone");
            String state = request.getParameter("state");
            String source = request.getParameter("source");
            String createTime = DateTimeUtil.getSysTime();
            String createBy = ((User)request.getSession().getAttribute("user")).getName();
            String description = request.getParameter("description");
            String contactSummary = request.getParameter("contactSummary");
            String nextContactTime = request.getParameter("nextContactTime");
            String address = request.getParameter("address");
            Clue c = new Clue();
            c.setId(id);
            c.setFullname(fullname);
            c.setAppellation(appellation);
            c.setOwner(owner);
            c.setCompany(company);
            c.setJob(job);
            c.setEmail(email);
            c.setPhone(phone);
            c.setWebsite(website);
            c.setMphone(mphone);
            c.setState(state);
            c.setSource(source);
            c.setCreateTime(createTime);
            c.setCreateBy(createBy);
            c.setDescription(description);
            c.setContactSummary(contactSummary);
            c.setNextContactTime(nextContactTime);
            c.setAddress(address);

            boolean flag = cs.save(c);
            PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得用户信息列表");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        PrintJson.printJsonObj(response,uList);
    }


}
