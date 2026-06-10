<?php
declare(strict_types=1);

namespace minipress\core\webui\actions;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

abstract class AbstractAction {
    abstract public function __invoke(Request $rq, Response $rs, array $args): Response;
}