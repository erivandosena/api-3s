<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class HomePage extends Controller
{
    /**
     * Mostra a página inicial do usuário logado
     *
     * @return \Illuminate\Contracts\View\View|\Illuminate\Contracts\View\Factory
     */
    public function __invoke()
    {
        return view('home');
    }
}
