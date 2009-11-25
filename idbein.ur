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

style header style section1 style page
style faq style content style screenLogo
style newOffer style footer style copyright

fun layout () = return <xml>
  <head>
    <link rel="stylesheet" type="text/css" href="/stylesheets/idbein.css"/>
  </head>

  <body>
    <div class={header}>
      <ul class={section1}>
        <li>All Offers</li>
      </ul>
    </div>

    <div class={page}>
      <div class={faq}>
        <h1>Are you in?</h1>
        <p>idbe.in (I'd be in) allows you to make offers.</p>
        <p>If people vote your offer past its threshold,
          then you can send them a 140 character reply.</p>
      </div>
      <div class={content}>
        <a link={Offer.new ()} class={newOffer}>+ add offer</a>
      </div>
    </div>

    <div class={footer}>
      <div class={copyright}>
        Copyright 2009 Larry Diehl, Zachary Berry &amp; Ian Turgeon
      </div>
    </div>

    <div class={screenLogo}/>
  </body>
</xml>

fun index () = Offer.list ()
