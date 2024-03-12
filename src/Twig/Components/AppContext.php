<?php

namespace App\Twig\Components;

use App\Model\AddressDto;
use Symfony\UX\LiveComponent\Attribute\AsLiveComponent;
use Symfony\UX\LiveComponent\Attribute\LiveAction;
use Symfony\UX\LiveComponent\DefaultActionTrait;

#[AsLiveComponent]
class AppContext
{
    use DefaultActionTrait;

    public ?AddressDto $address = null;

    #[LiveAction]
    public function setAddress(): void
    {
        $this->address = new AddressDto();
    }

    #[LiveAction]
    public function unsetAddress(): void
    {
        $this->address = null;
    }
}
