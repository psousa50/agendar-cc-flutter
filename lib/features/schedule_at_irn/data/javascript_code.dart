import '../../../core/data/models.dart';

class JavaScriptCode {
  static String messageHtml(String message, String fontSize) {
    var html = '''
        <div
      style='
        position: fixed;
        z-index: 1;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        align-items: center;
        justify-content: center;
        background-color: rgb(0,0,0);
        background-color: rgba(0,0,0,0.4);'
>
      <div style='background-color: #fefefe;
                  margin: 15% auto;
                  padding: 20px;
                  border: 1px solid #888;
                  width: 80%;
                  text-align: center;
      '>
      <span style='font-size: $fontSize;'>
        $message
      </span>
      </div>
  </div>
  ''';

    return html.replaceAll("\n", "");
  }

  static String helperFunctions() {
    var html = '''
      function replaceAll(s, searchValue, replaceValue) {
        const newString = s.replace(searchValue, replaceValue);
        return newString === s ? newString : replaceAll(newString, searchValue, replaceValue);
      }

      function fix(s) {
        return replaceAll(s, '"', "").normalize().trim();
      }

      function selectValue(select, value) {
        select.value = value;
        var evt = document.createEvent("HTMLEvents");
        evt.initEvent("change", false, true);
        select.dispatchEvent(evt);
      }

      function selectValueById(id, value) {
        selectValue(document.getElementById(id), value);
      }
    ''';

    return html.replaceAll("\n", "");
  }

  static String step1(IrnTableSelection table) {
    var html = '''

      function modalIsOpen() {
        return document.getElementById("myModal").style.display === "block";
      }

      function waitForModal() {
        return new Promise(function (resolve) {

          const interval = setInterval(function () {
            if (!modalIsOpen()) {
              clearInterval(interval);
              resolve();
            }
          }, 1000);
        });
      }

      var tok = document.getElementsByName("tok")[0].value;

      selectValueById("servico", "${table.serviceId}");
      selectValueById("distrito", "${table.districtId}");

      var radioData = document.getElementById("outra_data");
      radioData.checked = true;
      var evt = document.createEvent("HTMLEvents");
      evt.initEvent("change");
      radioData.dispatchEvent(evt);

      setTimeout(async function() {
        document.getElementById("data_input_3").value= "${table.date.toIso8601String().substring(0, 10)}";
        selectValueById("concelho", "${table.countyId}");

        await waitForModal();

        document.getElementById("btnSeguinte").click();
      }, 1000);
    
    ''';

    return html.replaceAll("\n", "");
  }

  static step2(IrnTableSelection table, IrnPlace place, UserDataState user) {
    var html = '''
      var selects = document.getElementsByTagName("select");
      var selectFound;


      for (var i = 0; i < selects.length; i++) {
        var s = selects[i].getAttribute("onChange");

        s = replaceAll(s, "'", '"').replace(");", "");

        var p = s.match(/(".*?"|[^",\s]+)(?=\s*,|\s*\$)/g) || [];
        var parts = p.map(fix);

        var date = parts[2];
        var placeName = parts[3];
        var tableNumber = parts[4];
        var address = parts[5];
        var postalCode = parts[6];
        var phone = parts[7];

        var found =
          date === '${table.date.toIso8601String().substring(0, 10)}' &&
          placeName === '${place.name}'.normalize() &&
          tableNumber === '${table.tableNumber}'.normalize() &&
          address === '${place.address}'.normalize() &&
          postalCode === '${place.postalCode}'.normalize() &&
          phone === '${place.phone}'.normalize();

        if ( found ) {
          selectFound = selects[i];
          break;
        }
      }

      var buttons = document.getElementsByTagName("button");
      for (var i = 0; i < buttons.length; i++) {
        var b = buttons[i];
        var onClick = b.getAttribute("onclick");
        if (onClick && onClick.startsWith("window.history.back")) {
          b.style.display='none';
        }
        if (onClick && onClick.startsWith("window.location.href='../index.php'")) {
          b.style.display='none';
        }
      }

      if (selectFound) {
        selectFound.value = "${table.timeSlot}";
        var evt = document.createEvent("HTMLEvents");
        evt.initEvent("change", false, true);
        selectFound.dispatchEvent(evt);
      }

      if (false && (!selectFound || selectFound.value !== "${table.timeSlot}")) {
        alert("Schedule.NotFound");
      }

      if (selectFound) {
        document.getElementById("nome").value = "${user.name}";
        document.getElementById("nic").value = "${user.citizenCardNumber}";
        document.getElementById("mail").value = "${user.email}";
        document.getElementById("telefone").value = "${user.phone}";
      }

      ''';

    return html.replaceAll("\n", "");
  }

  static javascript(
      IrnTableSelection table, IrnPlace place, UserDataState user) {
    var html = '''
    try {

      ${helperFunctions()}

      if (document.URL.includes("step1")) {
        ${step1(table)}
        document.body.insertAdjacentHTML("beforeend", "${messageHtml("Schedule.Redirecting", "20px")}");
      }

      if (document.URL.includes("step2")) {
        if (document.body) {
          if (document.body.innerHTML.trim().startsWith("<")) {
            ${step2(table, place, user)}
          } else {
            document.body.innerHTML = "${messageHtml("Schedule.RedirectingError", "40px")}";
          }
        }
      }

    }
    catch (e) {
      alert(e);
    }
  ''';

    return html.replaceAll("\n", "");

    // return "alert('${html.substring(0, 10)}')";
    // var x = '''
    //   try {
    //   alert('${html.replaceAll("\n", "").replaceAll("  ", " ").substring(0, 20)}')
    //   }
    //   catch (e) {
    //     alert(e)
    //   }
    // ''';

    // return x;
  }
}
