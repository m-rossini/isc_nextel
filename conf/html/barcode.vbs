        Function WBarCode( Valor )
          Dim f, f1, f2, i
          Dim texto
          Const fino = 1
          Const largo = 3
          Const altura = 50
          Dim BarCodes(99)
        
          if isempty(BarCodes(0)) then
            BarCodes(0) = "00110"
            BarCodes(1) = "10001"
            BarCodes(2) = "01001"
            BarCodes(3) = "11000"
            BarCodes(4) = "00101"
            BarCodes(5) = "10100"
            BarCodes(6) = "01100"
            BarCodes(7) = "00011"
            BarCodes(8) = "10010"
            BarCodes(9) = "01010"
            for f1 = 9 to 0 step -1
              for f2 = 9 to 0 Step -1
                f = f1 * 10 + f2
                texto = ""
                for i = 1 To 5
                  texto = texto & mid(BarCodes(f1), i, 1) + mid(BarCodes(f2), i, 1)
                next
                BarCodes(f) = texto
              next
            next
          end if
        
          'Desenho da barra
        
          ' Guarda inicial
          Ret = Ret &	"<img src=images/2.gif width=" & fino & " height=" & altura & " border=0>"
          Ret = Ret &	"<img src=images/1.gif width=" & fino & " height=" & altura & " border=0>"
          Ret = Ret &	"<img src=images/2.gif width=" & fino & " height=" & altura & " border=0>"
          Ret = Ret &	"<img src=images/1.gif width=" & fino & " height=" & altura & " border=0>"
          Ret = Ret &	"<img "
        
            texto = valor
            if len( texto ) mod 2 <> 0 then
              texto = "0" & texto
            end if
        
            ' Draw dos dados
            do while len(texto) > 0
              i = cint( left( texto, 2) )
              texto = right( texto, len( texto ) - 2)
              f = BarCodes(i)
              for i = 1 to 10 step 2
                if mid(f, i, 1) = "0" then
                  f1 = fino
                else
                  f1 = largo
                end if
        
              Ret = Ret & "src=images/2.gif width=" & f1 & " height=" & altura & " border=0><img "
        
              if mid(f, i + 1, 1) = "0" Then
                f2 = fino
              else
                  f2 = largo
              end if
        
              Ret = Ret & "src=images/1.gif width=" & f2 & " height=" & altura & " border=0><img "
               next
            loop
        
            ' Draw guarda final
            Ret = Ret & "      src=images/2.gif width=" & largo & " height=" & altura & " border=0>"
            Ret = Ret & " <img src=images/1.gif width=" & fino  & " height=" & altura & " border=0>"
            Ret = Ret & " <img src=images/2.gif width=1             height=" & altura & " border=0>"
        
            WBarCode = Ret
        End Function

