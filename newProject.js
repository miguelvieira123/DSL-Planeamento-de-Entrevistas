$(document).ready(function() {

  $(function () {
        $(".lined").linedtextarea({});
    });

$('#dsl_input_text').text("name: \"Projeto Natura\"\nmeta:\n  #\"Nome\"\n  #\"Idade\"\n  #\"Sexo\"\n  #\"Estado Civil\"\n  #\"Local de residência\"\n  #\"Profissão\"\n  #\"Formação Académica\"\n  #\"Contacto\"\n\nperguntas:\n  #\"Experiência académica e profissional\"\n  #\"Criação do Projeto (Surgimento da ideia e data/ano de criação)\"\n  #\"Entrada no projeto (caso não seja o criador)\"\n  #\"Colaboradores e ex colaboradores\"\n  #\"Objetivo(s) do projeto\"\n  #\"Área(s) de intervenção\"\n  #\"Trabalho realizado\"\n  #\"Neste momento o que se encontra a desenvolver\"\n  #\"Planos para o futuro\"\n\nurls:\n  #\"http://www.gpsmon.org/zip1/index.php\"");

  $('#load_example').click(function(){
    $('#dsl_input_text').val("\nname: Gammers\n\nmeta:\n    # idade\n    # nome\n    # morada\n    # telefone\n\nperguntas:\n    # primeiro jogo\n    # genero preferido\n    # jogo favorito\n    # comunidade a que pertence\n    # amigos\n    # (\"\\s*Porto[\\s]?\", morada ) montou servidores de jogos?\n    # ( idade>20 ) jogou Doom?\n\nurls:\n    # www.mp.pt");
  });




  // Gramatica
      $("#submitDSL").click(function () {
          var t = $('#dsl_input_text').val();
          $("#msg").empty();
          $("#msg").append('<img src="imgs/loading.gif" alt="loading" height="55" width="55" />');
          $.ajax({
              type: "POST",
              url: 'exec.php',
              data: {msg: "", phrase: t},
              success: function (data) {
                /*
                  $("#msg").append(
                  "<p> JSON: " + data +" </p>" // ver 'raw' JSON
                  );
                */
                $("#msg").empty();
                $("#msg").append('  <textarea id="result_xml" class="results" rows="32"></textarea>');

                  // remover erros anteriores
                  $(".lineno").removeClass("lineselect");
                  data = JSON.parse(data);
                  var linha_erro = -1;
                  for (var i = 0; i < data.msg.length; i++) {

                      // marcar linha com erro
                      var str = data["msg"][i];
                      var patt = new RegExp("line [0-9]+");
                      linha_erro = patt.exec(str);
                      var pos;
                      if(linha_erro != null){
                          pos = linha_erro[0].indexOf(' ');
                          var num = linha_erro[0].substr(pos+1,linha_erro[0].length);
                          $("#linha_"+num).addClass("lineselect");
                      }
                      //$("#msg").append("<p>" + data["msg"][i] + "<p>");
                      $("#result_xml").val( $("#result_xml").val() + data["msg"][i]+"\n");
                  }
                  if (data["succ"] == 0) {
                    $('#download_file').attr("disabled", false);
                    $("#download_file").css("background-color","#86B404");
                  }else {
                    $('#download_file').attr("disabled", true);
                    $("#download_file").css("background-color","#999966");
                  }

              }
          });
      });

//Download file
$("#download_file").click(function(){
  var content = $('#result_xml').val();
  uriContent = "data:application/octet-stream," + encodeURIComponent(content);
  saveAs(uriContent, "new_project.xml");
});

function saveAs(uri, filename) {
  var link = document.createElement('a');
  if (typeof link.download === 'string') {
    link.href = uri;
    link.download = filename;
    //Firefox requires the link to be in the body
    document.body.appendChild(link);
    //simulate click
    link.click();
    //remove the link when done
    document.body.removeChild(link);
  } else {
    window.open(uri);
  }
}


});
