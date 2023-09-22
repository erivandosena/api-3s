<?php

/**
 * Classe feita para manipulação do objeto Servico
 * feita automaticamente com programa gerador de software inventado por
 * @author Jefferson Uchôa Ponte
 */

namespace app3s\dao;

use PDO;
use PDOException;
use app3s\model\Servico;

class ServicoDAO extends DAO
{

    /**
     * @deprecated 1.0.17
     */
    public function fillById(Servico $servico)
    {

        $id = $servico->getId();
        $sql = "SELECT servico.id, servico.nome, servico.descricao, servico.tempo_sla, servico.visao, tipo_atividade.id as id_tipo_atividade_tipo_atividade, tipo_atividade.nome as nome_tipo_atividade_tipo_atividade, area_responsavel.id as id_area_responsavel_area_responsavel, area_responsavel.nome as nome_area_responsavel_area_responsavel, area_responsavel.descricao as descricao_area_responsavel_area_responsavel, area_responsavel.email as email_area_responsavel_area_responsavel, grupo_servico.id as id_grupo_servico_grupo_servico, grupo_servico.nome as nome_grupo_servico_grupo_servico FROM servico INNER JOIN tipo_atividade as tipo_atividade ON tipo_atividade.id = servico.id_tipo_atividade INNER JOIN area_responsavel as area_responsavel ON area_responsavel.id = servico.id_area_responsavel INNER JOIN grupo_servico as grupo_servico ON grupo_servico.id = servico.id_grupo_servico
                WHERE servico.id = :id
                 LIMIT 1000";

        try {
            $stmt = $this->connection->prepare($sql);

            if (!$stmt) {
                echo "<br>Mensagem de erro retornada: " . $this->connection->errorInfo()[2] . "<br>";
            }
            $stmt->bindParam(":id", $id, PDO::PARAM_INT);
            $stmt->execute();
            $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
            foreach ($result as $row) {
                $servico->setId($row['id']);
                $servico->setNome($row['nome']);
                $servico->setDescricao($row['descricao']);
                $servico->setTempoSla($row['tempo_sla']);
                $servico->setVisao($row['visao']);
                $servico->getTipoAtividade()->setId($row['id_tipo_atividade_tipo_atividade']);
                $servico->getTipoAtividade()->setNome($row['nome_tipo_atividade_tipo_atividade']);
                $servico->getAreaResponsavel()->setId($row['id_area_responsavel_area_responsavel']);
                $servico->getAreaResponsavel()->setNome($row['nome_area_responsavel_area_responsavel']);
                $servico->getAreaResponsavel()->setDescricao($row['descricao_area_responsavel_area_responsavel']);
                $servico->getAreaResponsavel()->setEmail($row['email_area_responsavel_area_responsavel']);
                $servico->getGrupoServico()->setId($row['id_grupo_servico_grupo_servico']);
                $servico->getGrupoServico()->setNome($row['nome_grupo_servico_grupo_servico']);
            }
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
        return $servico;
    }
}
