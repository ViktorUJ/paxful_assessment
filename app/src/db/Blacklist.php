<?php

declare(strict_types=1);

namespace app\DB;

use PDO;

class Blacklist
{
    private PDO $connection;

    public function __construct(PDO $connection)
    {
        $this->connection = $connection;
    }

    public function store(string $path, string $ipAddress): void
    {
        $stmt = $this->connection->prepare('INSERT INTO blacklisted (path, ip_address, created_at) VALUES (?, ?, now())');
        $stmt->execute([$path, $ipAddress]);
    }
}
