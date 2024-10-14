package org.natsukashiiz.githubactions.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MainController {

    @GetMapping("/")
    public String index() {
        return "Hello World!";
    }

    @GetMapping("/hello")
    public String hello() {
        return "Hello!";
    }
}
