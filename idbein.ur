(* sequence s *)
(* table Offer : { Id : int, Title : string } *)
(*   PRIMARY KEY Id *)

fun post poll = return <xml><body>
  <table>
    <tr> <th>Title:</th> <td>{[poll.Title]}</td> </tr>
  </table>
</body></xml>

fun main () = return <xml><body>
  <form>
    <table>
      <tr> <th>Title:</th> <td><textbox{#Title}/></td> </tr>
      <tr> <th/> <td><submit action={post}/></td> </tr>
    </table>
  </form>
</body></xml>



