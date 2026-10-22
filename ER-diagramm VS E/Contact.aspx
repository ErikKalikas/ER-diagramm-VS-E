<%@ Page Title="Töötajad" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.vb" Inherits="ER_diagramm_VS_E.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <p><asp:Label ID="LabelTeade" runat="server" EnableViewState="False"></asp:Label></p>

    <div class="table-responsive">
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="tootaja_id,tootamine_id"
        DataSourceID="SqlDataSource1" EmptyDataText="Andmed puuduvad." CssClass="table"
        OnRowUpdated="GridView1_RowUpdated">
        <Columns>
            <asp:CommandField ShowEditButton="True" EditText="Muuda" UpdateText="Salvesta" CancelText="Tühista" />
            <asp:BoundField DataField="tootaja_id" HeaderText="ID" SortExpression="tootaja_id" ReadOnly="True" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" ControlStyle-Width="110px" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" ControlStyle-Width="110px" />
            <asp:BoundField DataField="isikukood" HeaderText="Isikukood" SortExpression="isikukood" ControlStyle-Width="115px" />
            <asp:BoundField DataField="telefon" HeaderText="Telefon" SortExpression="telefon" ControlStyle-Width="95px" />
            <asp:BoundField DataField="e_post" HeaderText="E-post" SortExpression="e_post" ControlStyle-Width="190px" />
            <asp:TemplateField HeaderText="Ametikoht" SortExpression="amet">
                <ItemTemplate>
                    <asp:Label ID="LabelAmet" runat="server" Text='<%# Eval("amet_tekst") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="DropDownListAmet" runat="server" DataSourceID="SqlDataSource2_amet"
                        DataTextField="nimetus" DataValueField="ametikoha_tyyp_id" AppendDataBoundItems="True"
                        SelectedValue='<%# Bind("ametikoha_tyyp_id") %>'>
                        <asp:ListItem Value="">(puudub)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_amet" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT ametikoha_tyyp_id, nimetus FROM [Ametikoha_tyyp] ORDER BY nimetus"></asp:SqlDataSource>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Rühm" SortExpression="ruhm">
                <ItemTemplate>
                    <asp:Label ID="LabelRuhm" runat="server" Text='<%# Eval("ruhm_tekst") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <%-- 0 = köök (ilma rühmata) --%>
                    <asp:DropDownList ID="DropDownListRuhm" runat="server" DataSourceID="SqlDataSource2_ruhm"
                        DataTextField="nimetus" DataValueField="ruhm_id" AppendDataBoundItems="True"
                        SelectedValue='<%# Bind("ruhm_valik") %>'>
                        <asp:ListItem Value="">(vali)</asp:ListItem>
                        <asp:ListItem Value="0">köök</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_ruhm" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT ruhm_id, nimetus FROM [Ruhm] ORDER BY nimetus"></asp:SqlDataSource>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Algus" SortExpression="alguse_kp">
                <ItemTemplate>
                    <asp:Label ID="LabelAlgus" runat="server" Text='<%# Eval("algus_tekst") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <%-- Tühi = täna --%>
                    <asp:TextBox ID="TextBoxAlgus" runat="server" TextMode="Date" Width="135px" Text='<%# Bind("alguse_kp", "{0:yyyy-MM-dd}") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Lõpp" SortExpression="lopu_kp">
                <ItemTemplate>
                    <asp:Label ID="LabelLopp" runat="server" Text='<%# Eval("lopp") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <%-- Valik: töötab edasi või lõpetab kuupäeval; kuupäeva väli on näha ainult teise valiku korral --%>
                    <asp:DropDownList ID="DropDownListLopp" runat="server" SelectedValue='<%# Bind("lopu_valik") %>'
                        onchange="this.parentNode.querySelector('input').classList.toggle('d-none', this.value != 'kuupaev');">
                        <asp:ListItem Value="tootab">töötab</asp:ListItem>
                        <asp:ListItem Value="kuupaev">lõpetab kuupäeval</asp:ListItem>
                    </asp:DropDownList>
                    <asp:TextBox ID="TextBoxLopp" runat="server" TextMode="Date" Width="135px" Text='<%# Bind("lopu_kp", "{0:yyyy-MM-dd}") %>'
                        CssClass='<%# If(Eval("lopu_valik").ToString() = "kuupaev", "", "d-none") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </div>

    <%-- LEFT JOIN: näidatakse ka töötajaid, kellel pole ametikohta.
         Muutmisel: 1) uuendame tabelit Tootaja,
                    2) leiame (või loome) Ametikoht kirje valitud ameti ja rühma järgi,
                    3) kui töötajal on Tootamine kirje, uuendame seda; kui pole, lisame uue.
         Kõik sammud ühes tehingus: vea korral ei salvestata midagi. --%>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT Tootaja.tootaja_id, Tootamine.tootamine_id, Tootaja.eesnimi, Tootaja.perenimi, Tootaja.isikukood, Tootaja.telefon, Tootaja.e_post, Ametikoht.ametikoha_tyyp_id, ISNULL(Ametikoha_tyyp.nimetus, N'—') AS amet_tekst, CASE WHEN Ametikoht.on_kooki_koht = 1 THEN 0 ELSE Ametikoht.ruhm_id END AS ruhm_valik, CASE WHEN Ametikoht.on_kooki_koht = 1 THEN N'köök' ELSE ISNULL(Ruhm.nimetus, N'—') END AS ruhm_tekst, Tootamine.alguse_kp, ISNULL(CONVERT(nvarchar(10), Tootamine.alguse_kp, 104), N'—') AS algus_tekst, Tootamine.lopu_kp, CASE WHEN Tootamine.lopu_kp IS NULL THEN 'tootab' ELSE 'kuupaev' END AS lopu_valik, CASE WHEN Tootamine.tootamine_id IS NULL THEN N'—' WHEN Tootamine.lopu_kp IS NULL THEN N'töötab' ELSE CONVERT(nvarchar(10), Tootamine.lopu_kp, 104) END AS lopp FROM Tootaja LEFT JOIN Tootamine ON Tootamine.tootaja_id = Tootaja.tootaja_id LEFT JOIN Ametikoht ON Tootamine.ametikoht_id = Ametikoht.ametikoht_id LEFT JOIN Ametikoha_tyyp ON Ametikoht.ametikoha_tyyp_id = Ametikoha_tyyp.ametikoha_tyyp_id LEFT JOIN Ruhm ON Ametikoht.ruhm_id = Ruhm.ruhm_id ORDER BY Tootaja.perenimi, Tootaja.eesnimi"
        UpdateCommand="SET XACT_ABORT ON;
            DECLARE @ruhm int = NULLIF(@ruhm_valik, 0), @ametikoht int = NULL, @lopp date = NULL;
            BEGIN TRY BEGIN TRAN;
            UPDATE [Tootaja] SET [eesnimi] = @eesnimi, [perenimi] = @perenimi, [isikukood] = @isikukood, [telefon] = @telefon, [e_post] = @e_post WHERE [tootaja_id] = @tootaja_id;
            IF @lopu_valik = N'kuupaev' AND @lopu_kp IS NULL THROW 50001, N'Vali lõpu kuupäev (või töötab).', 1;
            IF @lopu_valik = N'kuupaev' SET @lopp = @lopu_kp;
            IF @ametikoha_tyyp_id IS NOT NULL
            BEGIN
                IF @ruhm_valik IS NULL THROW 50002, N'Vali rühm (või köök).', 1;
                SELECT TOP 1 @ametikoht = [ametikoht_id] FROM [Ametikoht]
                    WHERE [ametikoha_tyyp_id] = @ametikoha_tyyp_id AND ISNULL([ruhm_id], 0) = ISNULL(@ruhm, 0);
                IF @ametikoht IS NULL
                BEGIN
                    INSERT INTO [Ametikoht] ([ruhm_id], [ametikoha_tyyp_id], [on_kooki_koht])
                        VALUES (@ruhm, @ametikoha_tyyp_id, CASE WHEN @ruhm IS NULL THEN 1 ELSE 0 END);
                    SET @ametikoht = SCOPE_IDENTITY();
                END
            END
            IF @tootamine_id IS NOT NULL
                UPDATE [Tootamine] SET [ametikoht_id] = ISNULL(@ametikoht, [ametikoht_id]), [alguse_kp] = ISNULL(@alguse_kp, [alguse_kp]), [lopu_kp] = @lopp WHERE [tootamine_id] = @tootamine_id;
            IF @tootamine_id IS NULL AND @ametikoht IS NOT NULL
                INSERT INTO [Tootamine] ([tootaja_id], [ametikoht_id], [alguse_kp], [lopu_kp]) VALUES (@tootaja_id, @ametikoht, ISNULL(@alguse_kp, CAST(GETDATE() AS date)), @lopp);
            COMMIT TRAN; END TRY
            BEGIN CATCH IF @@TRANCOUNT != 0 ROLLBACK TRAN; THROW; END CATCH;">
        <UpdateParameters>
            <asp:Parameter Name="eesnimi" Type="String" />
            <asp:Parameter Name="perenimi" Type="String" />
            <asp:Parameter Name="isikukood" Type="String" />
            <asp:Parameter Name="telefon" Type="String" />
            <asp:Parameter Name="e_post" Type="String" />
            <asp:Parameter Name="ametikoha_tyyp_id" Type="Int32" />
            <asp:Parameter Name="ruhm_valik" Type="Int32" />
            <asp:Parameter Name="alguse_kp" Type="DateTime" />
            <asp:Parameter Name="lopu_valik" Type="String" />
            <asp:Parameter Name="lopu_kp" Type="DateTime" />
            <asp:Parameter Name="tootaja_id" Type="Int32" />
            <%-- Ilma tüübita: töötajal, kellel pole ametikohta, on tootamine_id = NULL (DBNull),
                 mida Int32-ks teisendada ei saa --%>
            <asp:Parameter Name="tootamine_id" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
