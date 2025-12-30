# CRMP

This is a Customer Relationship Management (CRM) Application built using CFML (ColdFusion Markup Language) and MySQL.
The goal of this project is to implement a real-world backend-driven web application with authentication, customer management, scheduling, and file handling.

About the Project

This CRM application helps manage customers and related activities in an organized way.
It follows a structured MVC-style approach using CFML components (.cfc) and views (.cfm).

In this application, a user can:

Register and login securely

Manage customer records (Add / View / Edit / Delete)

Schedule customer-related activities

Download customer data

Handle forgot & reset password flows

View logs and profile information

Upload files related to customers

All data is stored in MySQL, making this a complete database-driven CRM system.

Features

User Registration & Login

Forgot Password & Reset Password

Customer Management (CRUD)

Customer Scheduling

File Upload & Download

PDF Generation

Email Scheduling

Session Management

Server-side Form Validation

Modular & Maintainable Code Structure

Technologies Used

CFML (ColdFusion Markup Language)

MySQL

HTML

CSS

JavaScript

ColdFusion Server (Adobe / Lucee)

MVC-style Architecture

Folder Structure
CRM-Application/
│
├── components/
│   ├── customersAPI.cfc
│   └── CustomerService.cfc
│
├── css/
│
├── includes/
│   ├── header.cfm
│   └── footer.cfm
│
├── js/
│
├── upload/
│
├── views/
│   ├── add.cfm
│   ├── contact.cfm
│   ├── createSchedule.cfm
│   ├── cfschedule.cfm
│   ├── customer.cfm
│   ├── customers.cfm
│   ├── delete.cfm
│   ├── downloadCustomers.cfm
│   ├── edit.cfm
│   ├── editCustomer.cfm
│   ├── forgot.cfm
│   ├── forgotp.cfm
│   ├── forgotPassword.cfm
│   ├── formValidationFailed.cfm
│   ├── help.cfm
│   ├── home.cfm
│   ├── insert.cfm
│   ├── logs.cfm
│   ├── myprofile.cfm
│   ├── privacy.cfm
│   ├── register.cfm
│   ├── registeredUsers.cfm
│   ├── reset.cfm
│   ├── scheduleEmail.cfm
│   ├── scheduleRunner.cfm
│   ├── update.cfm
│   ├── view.cfm
│   └── view_downloadRequests.cfm
│
├── Application.cfc
├── controller.cfc
├── index.cfm
├── login.cfm
├── logout.cfm
├── router.cfm
├── schema.sql
└── README.md

Architecture Overview

Application.cfc – Application & session configuration

controller.cfc – Handles routing and request flow

router.cfm – Central request dispatcher

components (.cfc) – Business logic & database interaction

views (.cfm) – UI & user interaction

schema.sql – Database schema

This separation improves maintainability and scalability.
