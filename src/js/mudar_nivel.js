
$( ".change-level" ).click(function() {

    var dados = { nivel:  $(this).attr('nivel') };
    mudarNivel(dados);

});

function mudarNivel(dados){

    jQuery.ajax({
        type: "POST",
        url: "index.php?ajax=mudar_nivel",
        data: dados,
        success: function( data )
        {
        


            if(data.split(":")[1] == 'sucess'){
                
                $("#botao-modal-resposta").click(function(){
                    window.location.href='.';
                });
                $("#textoModalResposta").text("Nível Alterado Com Sucesso! ");                	
                $("#modalResposta").modal("show");
                
            }
            else
            {
                
                $("#textoModalResposta").text("Falha ao tentar alterar nível! ");                	
                $("#modalResposta").modal("show");
            }


        }
    });
    

}