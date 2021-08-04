package com.example.hello;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Cool Rest Controller which was written for demo purposes.
 */
@RestController
public class HelloController {
    public static final String HELLO_STR = "Hello, World!";

    @GetMapping("/")
    public String index() {
        return HELLO_STR;
    }
}
