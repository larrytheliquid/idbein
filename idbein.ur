sequence seq

table offers : { Id : int, Title : string, Threshold : int }
  PRIMARY KEY Id

table votes : { Id : int, OfferId : int }
  PRIMARY KEY Id
  CONSTRAINT C FOREIGN KEY OfferId REFERENCES offers (Id)

structure Offer = struct
  fun list () = rows <- queryX (SELECT * FROM offers)
    (fn row => <xml><tr>
      <form>
        <hidden{#Id} value={show row.Offers.Id}/>
        <td>0/{[row.Offers.Threshold]} <submit action={vote} value="I'd be in!"/></td>
        <td>{[row.Offers.Title]}</td>
      </form>
    </tr></xml>);
  return <xml><body>
    <table border=1>
      <tr> <th/> <th>Title</th> </tr>
      {rows}
    </table>
    <br/><hr/><br/>
    <table>
      <form>
        <tr> <th>Title:</th> <td><textbox{#Title}/></td> </tr>
        <tr> <th>Threshold:</th> <td><textbox{#Threshold}/></td> </tr>
        <tr> <th/> <td><submit action={create} value="Create"/></td> </tr>
      </form>
    </table>
  </body></xml>

  and create offer =
    id <- nextval seq;
    dml (INSERT INTO offers (Id, Title, Threshold)
         VALUES ({[id]}, {[offer.Title]}, {[readError offer.Threshold]}));
    list ()

  and vote offer =
    id <- nextval seq;
    dml (INSERT INTO votes (Id, OfferId)
         VALUES ({[id]}, {[readError offer.Id]}));
    list ()
end

fun index () = Offer.list ()
