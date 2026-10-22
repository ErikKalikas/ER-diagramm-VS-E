Public Class Contact
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

    End Sub

    ' Pärast muutmist: näitame teadet (vea korral jääb rida muutmisrežiimi)
    Protected Sub GridView1_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga muutmisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
            e.KeepInEditMode = True
        Else
            LabelTeade.Text = "Andmed salvestatud!"
            LabelTeade.ForeColor = System.Drawing.Color.Green
        End If
    End Sub

    ' Kustutamine: töötaja koos tema Tootamine kirjetega (ühes tehingus)
    Protected Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga kustutamisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
        Else
            LabelTeade.Text = "Töötaja kustutatud."
            LabelTeade.ForeColor = System.Drawing.Color.Green
        End If
    End Sub
End Class
