<?php

namespace app3s\controller;



class MainAjax
{

    public function main()
    {
        switch ($_GET['ajax']) {
            case 'ocorrencia':
                $controller = new OcorrenciaController();
                $controller->mainAjax();
                break;
            case 'mensagem_forum':
                $controller = new MensagemForumController();
                $controller->mainAjax();
                break;
            case 'status_ocorrencia':
                $controller = new StatusOcorrenciaController();
                $controller->mainAjax();
                break;
            case 'painel_kamban':
                $controller = new PainelKambanController();
                $controller->quadroKamban();
                break;
            case 'painel_tabela':
                $controller = new PainelTabelaController();
                $controller->tabelaChamados();
                break;
            case 'login':
                $controller = new UsuarioController();
                $controller->ajaxLogin();
                break;
            case 'mudar_nivel':
                $controller = new UsuarioController();
                $controller->mudarNivel();
                break;
            default:
                echo ':falha';
                break;
        }
    }
}
