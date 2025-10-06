package com.example.demo;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.messages.Message;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}


}

@RestController
class MyController {

	private final ChatClient chatClient;

	ChatMemory chatMemory;

	public MyController(ChatClient.Builder chatClientBuilder, ChatMemory chatMemory) {
		this.chatClient = chatClientBuilder
				.defaultAdvisors(MessageChatMemoryAdvisor.builder(chatMemory).build())
				.build();
		this.chatMemory = chatMemory;
	}

	@GetMapping("/ai")
	String generation(String userInput) {
		return this.chatClient.prompt()
				.user(userInput)
				.call()
				.content();
	}

	@GetMapping("/history")
	List<Message> history() {
		return chatMemory.get("default");
	}

	@GetMapping("/clear")
	void clear() {
		chatMemory.clear("default");
	}
}