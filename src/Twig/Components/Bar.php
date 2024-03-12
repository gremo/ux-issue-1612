<?php

namespace App\Twig\Components;

use Symfony\UX\LiveComponent\Attribute\AsLiveComponent;
use Symfony\UX\LiveComponent\Attribute\LiveArg;
use Symfony\UX\LiveComponent\Attribute\LiveAction;
use Symfony\UX\LiveComponent\DefaultActionTrait;

#[AsLiveComponent]
class Bar
{
    use DefaultActionTrait;

    #[LiveAction]
    public function bar(): void
    {
        dd("bar");
    }
}
