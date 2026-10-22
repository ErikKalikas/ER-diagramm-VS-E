<%@ Page Title="Töötajad" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.vb" Inherits="ER_diagramm_VS_E.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <p><asp:Label ID="LabelTeade" runat="server" EnableViewState="False"></asp:Label></p>

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="tootaja_id,tootamine_id"
        DataSourceID="SqlDataSource1" EmptyDataText="Andmed puuduvad." CssClass="table"
        OnRowUpdated="GridView1_RowUpdated">
        <Columns>
            <asp:CommandField ShowEditButton="True" EditText="Muuda" UpdateText="Salvesta" CancelText="Tühista" />
            <asp:BoundField DataField="tootaja_id" HeaderText="ID" SortExpression="tootaja_id" ReadOnly="True" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" />
            <asp:BoundField DataField="isikukood" HeaderText="Isikukood" SortExpression="isikukood" />
            <asp:BoundField DataField="telefon" HeaderText="Telefon" SortExpression="telefon" />
            <asp:BoundField DataField="e_post" HeaderText="E-post" SortExpression="e_post" />
            <asp:TemplateField HeaderText="Ametikoht" SortExpression="amet">
                <ItemTemplate>
                    <asp:Label ID="LabelAmet" runat="server" Text='<%# Eval("amet_tekst") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <%-- Ametikoht koos rühmaga, nt "kasvataja – Mõmmikud" --%>
                    <asp:DropDownList ID="DropDownListAmetikoht" runat="server" DataSourceID="SqlDataSource2_ametikoht"
                        DataTextField="nimi" DataValueField="ametikoht_id" AppendDataBoundItems="True"
                        SelectedValue='<%# Bind("ametikoht_id") %>'>
                        <asp:ListItem Value="">(puudub)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_ametikoht" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT Ametikoht.ametikoht_id, Ametikoha_tyyp.nimetus + N' – ' + CASE WHEN Ametikoht.on_kooki_koht = 1 THEN N'köök' ELSE Ruhm.nimetus END AS nimi FROM Ametikoht INNER JOIN Ametikoha_tyyp ON Ametikoht.ametikoha_tyyp_id = Ametikoha_tyyp.ametikoha_tyyp_id LEFT JOIN Ruhm ON Ametikoht.ruhm_id = Ruhm.ruhm_id ORDER BY Ametikoha_tyyp.nimetus"></asp:SqlDataSource>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ruhm" HeaderText="Rühm" SortExpression="ruhm" NullDisplayText="—" ReadOnly="True" />
            <asp:TemplateField HeaderText="Algus" SortExpression="alguse_kp">
                <ItemTemplate>
                    <asp:Label ID="LabelAlgus" runat="server" Text='<%# Eval("algus_tekst") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="TextBoxAlgus" runat="server" TextMode="Date" Text='<%# Bind("alguse_kp", "{0:yyyy-MM-dd}") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Lõpp" SortExpression="lopu_kp">
                <ItemTemplate>
                    <asp:Label ID="LabelLopp" runat="server" Text='<%# Eval("lopp") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <%-- Tühi = töötab praegu --%>
                    <asp:TextBox ID="TextBoxLopp" runat="server" TextMode="Date" Text='<%# Bind("lopu_kp", "{0:yyyy-MM-dd}") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <%-- LEFT JOIN: näidatakse ka töötajaid, kellel pole ametikohta.
         Muutmisel: 1) uuendame tabelit Tootaja,
                    2) kui töötajal on Tootamine kirje, uuendame seda,
                    3) kui pole, aga ametikoht valiti, lisame uue Tootamine kirje. --%>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT Tootaja.tootaja_id, Tootamine.tootamine_id, Tootaja.eesnimi, Tootaja.perenimi, Tootaja.isikukood, Tootaja.telefon, Tootaja.e_post, Tootamine.ametikoht_id, ISNULL(Ametikoha_tyyp.nimetus, N'—') AS amet_tekst, CASE WHEN Ametikoht.on_kooki_koht = 1 THEN N'köök' ELSE Ruhm.nimetus END AS ruhm, Tootamine.alguse_kp, ISNULL(CONVERT(nvarchar(10), Tootamine.alguse_kp, 104), N'—') AS algus_tekst, Tootamine.lopu_kp, CASE WHEN Tootamine.tootamine_id IS NULL THEN N'—' WHEN Tootamine.lopu_kp IS NULL THEN N'töötab' ELSE CONVERT(nvarchar(10), Tootamine.lopu_kp, 104) END AS lopp FROM Tootaja LEFT JOIN Tootamine ON Tootamine.tootaja_id = Tootaja.tootaja_id LEFT JOIN Ametikoht ON Tootamine.ametikoht_id = Ametikoht.ametikoht_id LEFT JOIN Ametikoha_tyyp ON Ametikoht.ametikoha_tyyp_id = Ametikoha_tyyp.ametikoha_tyyp_id LEFT JOIN Ruhm ON Ametikoht.ruhm_id = Ruhm.ruhm_id ORDER BY Tootaja.perenimi, Tootaja.eesnimi"
        UpdateCommand="SET XACT_ABORT ON;
            BEGIN TRY BEGIN TRAN;
            UPDATE [Tootaja] SET [eesnimi] = @eesnimi, [perenimi] = @perenimi, [isikukood] = @isikukood, [telefon] = @telefon, [e_post] = @e_post WHERE [tootaja_id] = @tootaja_id;
            IF @tootamine_id IS NOT NULL
                UPDATE [Tootamine] SET [ametikoht_id] = ISNULL(@ametikoht_id, [ametikoht_id]), [alguse_kp] = ISNULL(@alguse_kp, [alguse_kp]), [lopu_kp] = @lopu_kp WHERE [tootamine_id] = @tootamine_id;
            IF @tootamine_id IS NULL AND @ametikoht_id IS NOT NULL
                INSERT INTO [Tootamine] ([tootaja_id], [ametikoht_id], [alguse_kp], [lopu_kp]) VALUES (@tootaja_id, @ametikoht_id, ISNULL(@alguse_kp, CAST(GETDATE() AS date)), @lopu_kp);
            COMMIT TRAN; END TRY
            BEGIN CATCH IF @@TRANCOUNT != 0 ROLLBACK TRAN; THROW; END CATCH;">
        <UpdateParameters>
            <asp:Parameter Name="eesnimi" Type="String" />
            <asp:Parameter Name="perenimi" Type="String" />
            <asp:Parameter Name="isikukood" Type="String" />
            <asp:Parameter Name="telefon" Type="String" />
            <asp:Parameter Name="e_post" Type="String" />
            <asp:Parameter Name="ametikoht_id" Type="Int32" />
            <asp:Parameter Name="alguse_kp" Type="DateTime" />
            <asp:Parameter Name="lopu_kp" Type="DateTime" />
            <asp:Parameter Name="tootaja_id" Type="Int32" />
            <asp:Parameter Name="tootamine_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
