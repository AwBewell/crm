package com.bjpowernode.crm.workbench.web.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到线索控制器");

        String path = request.getServletPath();

        if ("/workbench/clue/xxx.do".equals(path)){
           // xxx(request,response);

        }else if ("/workbench/clue/xxx.do".equals(path)){
            //xxx(request,response);
        }

    }




}
