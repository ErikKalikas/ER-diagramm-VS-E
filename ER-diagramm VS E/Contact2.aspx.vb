Imports System

Public Class Contact2
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

    End Sub

    ' Pärast rühma lisamist: näitame teadet, värskendame tabelit ja rühmade ripploendit (laste arv)
    Protected Sub DetailsView1_ItemInserted(sender As Object, e As DetailsViewInsertedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga rühma lisamisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
            e.KeepInInsertMode = True
        Else
            LabelTeade.Text = "Laps lisatud rühma!"
            LabelTeade.ForeColor = System.Drawing.Color.Green
            GridView1.DataBind()
            DetailsView1.DataBind()
        End If
    End Sub
End Class
