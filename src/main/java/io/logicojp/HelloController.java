package io.logicojp;

import java.util.List;
import java.util.Map;

import io.micronaut.http.HttpHeaders;
import io.micronaut.http.MediaType;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Produces;

@Controller("/env")
public class HelloController {

    @Get("/headers")
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String, List<String>> getHeaders(HttpHeaders headers) {
        return headers.asMap();
    }
}
