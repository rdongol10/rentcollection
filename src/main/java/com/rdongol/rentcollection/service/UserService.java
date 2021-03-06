package com.rdongol.rentcollection.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.rdongol.rentcollection.model.User;
import com.rdongol.rentcollection.repository.UserRepository;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;

	public List<User> findAll() {
		return (List<User>) userRepository.findAll();
	}

	public Optional<User> findById(Long id) {
		return userRepository.findById(id);
	}

	public User save(User user) {
		return userRepository.save(user);
	}

	public void deleteById(Long id) {
		userRepository.deleteById(id);
	}

	public boolean existUserByLoginName(String loginName) {
		return userRepository.existsUserByLoginName(loginName);
	}

	public User findUserByUserName(String loginName) {
		return userRepository.findUserByLoginName(loginName);
	}
	
	public User findUserByEmailAddress(String emailAddress) {
		return userRepository.findUserByEmailAddress(emailAddress);
	}
}
