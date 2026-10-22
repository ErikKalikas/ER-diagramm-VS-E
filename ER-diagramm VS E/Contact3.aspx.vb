Public Class Contact3
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

    End Sub

    ' Pärast lisamist: näitame teadet, värskendame tabelit ja vormi ripploendeid (lapsed, laste arv rühmas)
    Protected Sub DetailsView1_ItemInserted(sender As Object, e As DetailsViewInsertedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga lisamisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
            e.KeepInInsertMode = True
        Else
            LabelTeade.Text = "Salvestatud!"
            LabelTeade.ForeColor = System.Drawing.Color.Green
            GridView1.DataBind()
            DetailsView1.DataBind()
        End If
    End Sub

    Protected Sub GridView1_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga muutmisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
            e.KeepInEditMode = True
        End If
    End Sub

    Protected Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga kustutamisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
        End If
    End Sub
End Class
