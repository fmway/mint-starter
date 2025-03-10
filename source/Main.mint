component Main {
  style app {
    justify-content: center;
    flex-direction: column;
    align-items: center;
    display: flex;

    background-color: #282C34;
    height: 100vh;
    width: 100vw;

    font-family: Open Sans;
    font-weight: bold;
  }

  style babi {
    color: #ffff;
  }

  fun render : Html {
    <div::app>
      <h1::babi>
        <{ "Woylah" }>
      </h1>

      <Logo/>

      <Info mainPath="source/Main.mint"/>

      <Link href="https://www.mint-lang.com/">
        "Learn AdMint"
      </Link>
    </div>
  }
}
