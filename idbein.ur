sequence seq

table offers : { Id : int, Title : string, Threshold : int, VotesCount : int }
  PRIMARY KEY Id

table votes : { Id : int, OfferId : int }
  PRIMARY KEY Id
  CONSTRAINT C FOREIGN KEY OfferId REFERENCES offers(Id)
  ON DELETE RESTRICT

structure Offer = struct
  fun list () = rows <- queryX (SELECT * FROM offers)
    (fn row => <xml><tr>
      <form>
        <hidden{#Id} value={show row.Offers.Id}/>
        <td>
          <submit action={vote} value="I'd be in"/>
          {[row.Offers.VotesCount]}/{[row.Offers.Threshold]}
        </td>
        <td>{[row.Offers.Title]}</td>
      </form>
    </tr></xml>);
  return <xml><body>
    <a link={new ()}>Offer something</a>

    <br/><hr/><br/>

    <table border=1>
      <tr> <th/> <th>Title</th> </tr>
      {rows}
    </table>
  </body></xml>

  and new () = return <xml><body>
    <table>
      <form>
        <tr> <th>Title:</th> <td><textbox{#Title}/> e.g. Intro to theorem proving</td> </tr>
        <tr> <th>Threshold:</th> <td><textbox{#Threshold}/> e.g. 15</td> </tr>
        <tr> <th/> <td><submit action={create} value="Offer this"/></td> </tr>
      </form>
    </table>
  </body></xml>

  and create offer =
    id <- nextval seq;
    dml (INSERT INTO offers (Id, Title, Threshold, VotesCount)
         VALUES ({[id]}, {[offer.Title]}, {[readError offer.Threshold]}, {[0]}));
    list ()

  and vote offer =
    id <- nextval seq;
    dml (INSERT INTO votes (Id, OfferId)
         VALUES ({[id]}, {[readError offer.Id]}));
    votesCount <- oneRowE1 (SELECT offers.VotesCount AS VC FROM offers
                            WHERE offers.Id = {[readError offer.Id]});
    dml (UPDATE offers SET VotesCount = {[votesCount + 1]}
         WHERE Id = {[readError offer.Id]});
    list ()
end

style header

fun layout () = return <xml>
  <head>
    <link rel="stylesheet" type="text/css" href="http://adam.chlipala.net/style.css"/>
  </head>

  <body>
    <div id={header}>
      <ul id="section-1">
        <li>All Polls</li>
      </ul>
    </div>

    <div id="page">
      <div id="faq">
        <h1>Are you in?</h1>
        <p>idbe.in (I’d be in) allows you to create polls.</p>
        <p>If people vote on your offer past its threshold,
          then you can send them a 140 character message.</p>
      </div>
      <div id="content">
        <a link={Offer.new ()}>Offer something</a>

      </div>
    </div>

    <div id="footer">
      <div id="copyright">
        Copyright 2009 Larry Diehl, Zachary Berry &amp; Ian Turgeon
      </div>
    </div>
  </body>
</xml>

fun index () = Offer.list ()
