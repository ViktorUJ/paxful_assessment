<?php

declare(strict_types=1);

require __DIR__ . '/../vendor/autoload.php';

$uri = null;
if (isset($_SERVER['REQUEST_URI'])) {
    $requestUriParts = explode('?', $_SERVER['REQUEST_URI'], 2);
    $uri = $requestUriParts[0];
}

try {
    router((string) $uri);
} catch (Throwable $e) {
    http_response_code(500);
    if (getenv('APP_ENV') === 'dev') {
        echo $e->getMessage();
    } else {
        echo 'Houston, we have a problem, but do not worry, because we are already working on it.';
    }
}


function router(string $path)
{
    switch ($path) {
        case '/':
            mainAction();
            break;
        case '/blacklisted':
            blacklistedAction();
            break;
        default:
            http_response_code(404);
    }
}

function mainAction(): void
{
    $number = $_GET['n'] ?? null;

    if (!is_numeric($number) && $number % 1 === 0) {
        http_response_code(400);
        echo 'Please enter integer value into n param.';

        return;
    }

    echo $number * $number;
}

function blacklistedAction(): void
{
    $path = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}";
    $ipAddress = $_SERVER['REMOTE_ADDR'];

    (new \app\Database\Blacklist(\app\Database\Connection::getInstance()))->store($path, $ipAddress);

    sendEmail('test@domain.com', 'Blacklisted IP Address', 'IP: ' . $ipAddress);
    http_response_code(444);
}

function sendEmail(string $to, string $subject, string $body): int
{
    $smtpHost = getenv('MAILER_HOST') ?: '127.0.0.1';
    $smtpPort = (int) (getenv('MAILER_PORT') ?: 25);
    $smtpUser = getenv('MAILER_USER') ?: '';
    $smtpPassword = getenv('MAILER_PASSWORD') ?: '';

    $transport = (new Swift_SmtpTransport($smtpHost, $smtpPort))
        ->setUsername($smtpUser)
        ->setPassword($smtpPassword);

    $mailer = new Swift_Mailer($transport);

    $message = (new Swift_Message($subject))
        ->setFrom(['app@mail.com'])
        ->setTo([$to])
        ->setBody($body);

    return $mailer->send($message);
}
