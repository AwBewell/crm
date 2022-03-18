package com.bjpowernode.crm.web.filter;

import jakarta.servlet.*;

import java.io.IOException;

public class EncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {
        //过滤字符编码的过滤器
        servletRequest.setCharacterEncoding("UTF-8");
        servletResponse.setContentType("test/html,charset=utf-8");
        //请求放行
        chain.doFilter(servletRequest,servletResponse);
    }
}
