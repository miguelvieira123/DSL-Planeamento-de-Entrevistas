<?php
      $vars = $_POST;

      // tornar a string segura
      if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        $texto = mres( $vars["phrase"] );
        $vars["machine"] = "windows";
      } else {
        $texto = escapeshellarg($vars["phrase"]);
        $vars["machine"] = "linux";
      }



      //executar gramatica
      exec("perl ./gramaticas/gramatica_teste.pl ".$texto, $out, $code);

      // recolher prints
      $i=0;
      foreach($out as $line) {
        if (strpos("_".$line, 'Marpa::R2 exception') !== false) {
          //nothing...
        }else {
          $vars["msg"][$i] = $line;
        }
          $i++;
      }


      //enviar mensagens para o cliente
      $vars["succ"] = $code;
      echo json_encode($vars);


      // funcoes auxiliares --------------------------------------------
      function mres($value){
          $search = array("\\",  "\x00", "\n",  "\r",  "'",  '"', "\x1a","<", ">" );
          $replace = array("\\\\","\\0","\\n", "\\r", "\'", '\"', "\\Z", "^<","^>");
          return str_replace($search, $replace, $value);
      }









 ?>
