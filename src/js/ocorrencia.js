

$(document).ready(function(e) {
	$("#insert_form_ocorrencia").on('submit', function(e) {
		e.preventDefault();
        $('#modalAddOcorrencia').modal('hide');

		var dados = jQuery( this ).serialize();
		jQuery.ajax({
            type: "POST",
            url: "index.php?ajax=ocorrencia",
            data: dados,
            success: function( data )
            {
            

            	if(data.split(":")[1] == 'sucesso'){
            		
            		$("#botao-modal-resposta").click(function(){
            			window.location.href='?page=ocorrencia';
            		});
            		$("#textoModalResposta").text("Ocorrencia enviado com sucesso! ");                	
            		$("#modalResposta").modal("show");
            		
            	}
            	else
            	{
            		
                	$("#textoModalResposta").text("Falha ao inserir Ocorrencia, fale com o suporte. ");                	
            		$("#modalResposta").modal("show");
            	}

            }
        });
		
		
	});
	
	
});
   
