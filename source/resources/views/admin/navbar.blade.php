
<nav class="navbar navbar-expand-lg navbar-light bg-light">

    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
                <a class="nav-link" href=".">Início<span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="?page=ocorrencia&cadastrar=1">Abrir Chamado</a>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                    data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Paineis
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="?page=painel_kamban">Kanban</a>
                    <a class="dropdown-item" href="?page=painel_tabela">Tabela</a>
                </div>
            </li>






            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                    data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Gerenciamento
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="?page=servico">Serviços</a>


                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="{{route('divisions.index')}}">Unidades</a>
                    <a class="dropdown-item" href="{{route('users.index')}}">Usuários</a>
                </div>
            </li>


        </ul>

        <form action="" method="get">

            <div class="input-group">
                <input type="hidden" name="page" value="ocorrencia">
                <input type="text" name="selecionar" class="form-control" placeholder="Número do chamado"
                    aria-label="Número do Chamado" aria-describedby="button-addon2">
                <div class="input-group-append">
                    <button class="btn btn-outline-secondary" type="form" id="button-addon2">
                        <i class="fa fa-search"></i>
                    </button>
                </div>
            </div>
        </form>

        <div class="btn-group">
            <button class="btn btn-light dropdown-toggle" type="button" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false">
                <i class="fa fa-user"></i> Olá, Jefferson
            </button>

            <div class="dropdown-menu dropright">
                <button type="button" disabled class="dropdown-item">
                    Setor: DTI
                </button>




                <hr>
                <button type="button" nivel="a" disabled class="dropdown-item change-level">
                    Perfil Admin
                </button>

                <button type="button" nivel="t" id="change-to-tec" class="dropdown-item change-level">
                    Perfil Técnico
                </button>
                <button type="button" nivel="c" id="change-to-default"
                    class="dropdown-item change-level">
                    Perfil Comum
                </button>
                <hr>




                <a class="dropdown-item" href="{{ route('logout') }}"
                onclick="event.preventDefault();
            document.getElementById('logout-form').submit();">
                {{ __('Logout') }}
            </a>

            <form id="logout-form" action="{{ route('logout') }}" method="post" class="d-none">
                @csrf
            </form>
            </div>
        </div>

    </div>
</nav>