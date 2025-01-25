    <link rel="stylesheet" href="pages/register.css">
    <div class="register-container">
        <h2>Registrazione</h2>
        <form action="index.php" method="post" id="register-form">
            <input type="hidden" name="action" value="register">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <label for="confirm-password">Conferma Password:</label>
            <input type="password" id="confirm-password" name="confirm-password" required>

            <button type="submit" id="register-button" disabled>Registrati</button>
        </form>
        <p id="error-message" class="register-error"></p>
    </div>
    <script src="pages/register.js"></script>
