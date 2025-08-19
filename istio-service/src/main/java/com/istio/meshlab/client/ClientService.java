package com.istio.meshlab.client;

import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;


@Path("/api/greeting/hello")
@RegisterRestClient(configKey = "external-api")
public interface ClientService {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    String helloClient();
}
