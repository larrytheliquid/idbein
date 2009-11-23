sequence seq
table offers : { Id : int, Title : string, Threshold : int }
  PRIMARY KEY Id

structure Offer = struct
  fun list () = rows <- queryX (SELECT * FROM offers)
    (fn row => <xml><tr>
      <form>
        <hidden{#Id} value={show row.Offers.Id}/>
        <td><submit action={vote} value="I'd be in!"/></td>
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
        <tr> <th/> <td><submit action={create} value="Create"/></td> </tr>
      </form>
    </table>
  </body></xml>

  and create offer =
    id <- nextval seq;
    dml (INSERT INTO offers (Id, Title, Threshold)
         VALUES ({[id]}, {[offer.Title]}, {[0]}));
    list ()

  and vote offer =
    dml (UPDATE offers SET Threshold = {[33]}
         WHERE Id = {[readError offer.Id]});
    list ()
end

fun index () = Offer.list ()
