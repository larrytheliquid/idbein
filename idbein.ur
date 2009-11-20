sequence s
table offer : { Id : int, Title : string }
  PRIMARY KEY Id

structure Offer = struct
  fun post offer = return <xml><body>
    <table>
      <tr> <th>Title:</th> <td>{[offer.Title]}</td> </tr>
    </table>
  </body></xml>

  fun list () = return <xml><body>
    <form>
      <table>
        <tr> <th>Title:</th> <td><textbox{#Title}/></td> </tr>
        <tr> <th/> <td><submit action={post}/></td> </tr>
      </table>
    </form>
  </body></xml>
end

fun main () = return <xml><body>
  <a link={Offer.list ()}>Checkout offers</a>
</body></xml>


