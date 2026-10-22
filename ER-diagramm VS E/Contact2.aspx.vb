Imports System

Public Class Contact2
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

    End Sub

    ' Pärast lapse lisamist: näitame teadet, värskendame tabelit ja rühmade ripploendit (laste arv)
    Protected Sub DetailsView1_ItemInserted(sender As Object, e As DetailsViewInsertedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga lapse lisamisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
            e.KeepInInsertMode = True
        Else
            LabelTeade.Text = "Laps lisatud!"
            LabelTeade.ForeColor = System.Drawing.Color.Green
            GridView1.DataBind()
            DetailsView1.DataBind()
        End If
    End Sub

    ' Rühma muutmine tabelis
    Protected Sub GridView1_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga rühma muutmisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
            e.KeepInEditMode = True
        Else
            LabelTeade.Text = "Rühm salvestatud!"
            LabelTeade.ForeColor = System.Drawing.Color.Green
            DetailsView1.DataBind()
        End If
    End Sub

    ' Lapse kustutamine (koos tema rühmade, järjekorra ja puudumistega); värskendame ka vormi ripploendit
    Protected Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga kustutamisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
        Else
            LabelTeade.Text = "Laps kustutatud."
            LabelTeade.ForeColor = System.Drawing.Color.Green
            DetailsView1.DataBind()
        End If
    End Sub
End Class
