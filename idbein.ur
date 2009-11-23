sequence seq
table offers : { Id : int, Title : string }
  PRIMARY KEY Id

structure Offer = struct
  fun list () = rows <- queryX (SELECT * FROM offers)
    (fn row => <xml><tr>
      <td>{[row.Offers.Title]}</td>
    </tr></xml>);
  return <xml><body>
    <table border=1>
      <tr> <th>Title</th> </tr>
      {rows}
    </table>
    <br/><hr/><br/>
    <form>
      <table>
        <tr> <th>Title:</th> <td><textbox{#Title}/></td> </tr>
        <tr> <th/> <td><submit action={create}/></td> </tr>
      </table>
    </form>
  </body></xml>

  and create offer = list ()
end

fun index () = Offer.list ()
