<!DOCTYPE html>
<html>
<head>
    <title>Contact + Request Changes</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            margin: 0;
            padding: 40px;
        }

        /* container holding both sections */
        .container {
            display: flex;
            justify-content: center;
            gap: 40px;
        }

        /* left and right boxes */
        .box, .contact-wrapper {
            width: 420px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.15);
        }

        .contact-wrapper h2,
        .box h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        label {
            margin-top: 12px;
            display: block;
            font-weight: bold;
            color: #444;
        }

        input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
            outline: none;
        }

        textarea {
            resize: none;
        }

        .btn {
            width: 100%;
            display: block;
            margin-top: 18px;
            padding: 12px;
            background: #007bff;
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 15px;
            cursor: pointer;
            transition: 0.2s;
            text-align: center;
            text-decoration: none;
        }

        .btn:hover {
            background: #0056b3;
        }

        .token-btn { background: #28a745; }
        .token-btn:hover { background: #1f7c34; }

        .username-btn { background:#007bff; }
        .email-btn { background:#17a2b8; }
        .delete-btn { background:#dc3545; }

        .msg {
            margin-top: 20px;
            color: green;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="container">

    <!-- LEFT SIDE — CONTACT FORM -->
    <div class="contact-wrapper">
        <h2>Contact Support</h2>

        <form method="post" action="">
            <label>Your Name</label>
            <input type="text" name="name" required>

            <label>Your Email</label>
            <input type="email" name="email" required>

            <label>Your Message</label>
            <textarea name="message" rows="5" required></textarea>

            <button type="submit" class="btn">Send Message</button>

           
        </form>

        <cfif structKeyExists(form, "message")>

    <!--- Send email to admin --->
    <cfmail 
        to="jahnavibhanu124@gmail.com"
        from="#form.email#"
        subject=" Message from #form.name#"
        type="html">

        <p><strong>Name:</strong> #form.name#</p>
        <p><strong>Email:</strong> #form.email#</p>
        <p><strong>Message:</strong><br>#form.message#</p>

    </cfmail>

    <div class="msg">Your message has been sent successfully.</div>
</cfif>

        <cfif structKeyExists(form, "getToken")>
            <cfset tokenValue = createUUID()>
            <div class="msg">
                Token Generated:<br><br>
                <strong>#tokenValue#</strong>
            </div>
        </cfif>
    </div>


    

</div>

</body>
</html>
