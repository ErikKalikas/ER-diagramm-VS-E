Public Class Contact3
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

    End Sub

    ' Laps valitud: näitame lisamise vormi
    Protected Sub GridView1_SelectedIndexChanged(sender As Object, e As EventArgs)
        DetailsView1.Visible = True
    End Sub

    ' Puudumine lisatud: värskendame teist tabelit
    Protected Sub DetailsView1_ItemInserted(sender As Object, e As DetailsViewInsertedEventArgs)
        GridView2.DataBind()
    End Sub
End Class
