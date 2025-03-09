def queens(n):
    def q: . as $pl 
        | $pl[3] as $r | select($r < n)
        | range(0; n)
        | def place: . as $c
            | all($pl[0][]; . != $c)
            and all($pl[1][]; . != $r+$c)
            and all($pl[2][]; . != $r-$c); 
          select(place)
        | [$pl[0]+[.], $pl[1]+[$r+.],
           $pl[2]+[$r-.], $r+1];
    def toletter: 
        "abcdefghijklmnopqrstuvwxyz"[.:.+1];
    def fund_solut(f):
        def inverse:
            to_entries | map([.value, .key]) 
            | sort | map(.[1]);
        def variants:
            [., inverse] | map(., reverse)
            | map(., map(n-1-.)) 
            | map(map(toletter) | add);
        foreach f as $i 
            ([null, {}]; .[1] as $ml
            | ($i | variants) as $nl
            | if all($nl[]; in($ml) | not) then
                [$i, ($ml | .[$nl[]]=null)]
              else
                [null, $ml] end;
            .[0])
        | select (. != null);
    fund_solut([[], [], [], 0] | recurse(q)
        | select(.[3] == n) | .[0]) 
    | map(toletter) | to_entries
    | map(.value+(.key+1 | tostring)) | sort;
queens(8)

