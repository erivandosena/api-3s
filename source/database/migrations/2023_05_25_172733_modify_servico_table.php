<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
  /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::rename('servico', 'services');

        Schema::table('services', function (Blueprint $table) {
            $table->renameColumn('nome', 'name');
            $table->renameColumn('descricao', 'description');
            $table->renameColumn('tempo_sla', 'sla');
            $table->renameColumn('id_area_responsavel', 'division_id');
            $table->renameColumn('visao', 'role');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('services', function (Blueprint $table) {
            $table->renameColumn('name', 'nome');
            $table->renameColumn('description', 'descricao');
            $table->renameColumn('sla', 'tempo_sla');
            $table->renameColumn('division_id', 'id_area_responsavel');
            $table->renameColumn('role', 'visao');
            $table->dropTimestamps();
        });

        Schema::rename('services', 'servico');
    }
};
