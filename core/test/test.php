<?php

namespace minipress\core\tests;

use PHPUnit\Framework\TestCase;
use minipress\core\webui\providers\CsrfTokenProvider;
use minipress\core\webui\providers\AuthProvider;

class MiniPressAppTest extends TestCase
{
    public function testCsrfTokenProvider()
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        $csrfProvider = new CsrfTokenProvider();
        $token = $csrfProvider->generate();
        
        $this->assertNotEmpty($token);
        $this->assertEquals($token, $_SESSION['csrf_token']);
        try {
            $csrfProvider->check($token);
            $this->assertTrue(true);
        } catch (\Exception $e) {
            $this->fail("token bon et refuser par l app: " . $e->getMessage());
        }
        try {
            $csrfProvider->check("azertyuiop");
        } catch (\Exception $e) {
            $this->assertNotEmpty($e->getMessage());
        }
    }

    public function testAuthProviderSessionLogic()
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        unset($_SESSION['user']);
        $authProvider = new AuthProvider();
        $this->assertNull($authProvider->getSignedInUser());
        $_SESSION['user'] = [
            'id' => 1,
            'email' => 'alice.dupont@email.com',
            'role' => 'admin'
        ];
        $userSession = $authProvider->getSignedInUser();
        $this->assertIsArray($userSession);
        $this->assertEquals(1, $userSession['id']);
        $this->assertEquals('alice.dupont@email.com', $userSession['email']);
        $this->assertEquals('admin', $userSession['role']);
        unset($_SESSION['user']);
    }
}