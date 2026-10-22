<%@ Page Title="Lapsed" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact2.aspx.vb" Inherits="ER_diagramm_VS_E.Contact2" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <h3>Lisa laps rühma</h3>
    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="ruhmas_olek_id"
        DataSourceID="SqlDataSource1_ruhmas_olek" DefaultMode="Insert" Height="50px" Width="400px"
        OnItemInserted="DetailsView1_ItemInserted">
        <Fields>
            <asp:TemplateField HeaderText="Laps">
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownListLaps" runat="server" DataSourceID="SqlDataSource2_laps"
                        DataTextField="nimi" DataValueField="laps_id" SelectedValue='<%# Bind("laps_id") %>'>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_laps" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT laps_id, eesnimi + ' ' + perenimi AS nimi FROM [Laps] ORDER BY perenimi"></asp:SqlDataSource>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Rühm (lapsi/kohti)">
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownListRuhm" runat="server" DataSourceID="SqlDataSource2_ruhm"
                        DataTextField="nimi" DataValueField="ruhm_id" SelectedValue='<%# Bind("ruhm_id") %>'>
                    </asp:DropDownList>
                    <%-- Rühma nimi koos praeguse laste arvu ja kohtade arvuga, nt "Mõmmikud (1/14)" --%>
                    <asp:SqlDataSource ID="SqlDataSource2_ruhm" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT Ruhm.ruhm_id, Ruhm.nimetus + ' (' + CAST((SELECT COUNT(*) FROM Ruhmas_olek WHERE Ruhmas_olek.ruhm_id = Ruhm.ruhm_id AND CAST(GETDATE() AS date) BETWEEN Ruhmas_olek.alguse_kp AND ISNULL(Ruhmas_olek.lopu_kp, '9999-12-31')) AS varchar(10)) + '/' + CAST(Ruhm.kohtade_arv AS varchar(10)) + ')' AS nimi FROM Ruhm ORDER BY Ruhm.nimetus"></asp:SqlDataSource>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Alguse kuupäev (tühi = täna)">
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBoxAlgus" runat="server" TextMode="Date" Text='<%# Bind("alguse_kp") %>'></asp:TextBox>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowInsertButton="True" InsertText="Lisa" CancelText="Tühista" NewText="Uus" />
        </Fields>
    </asp:DetailsView>

    <%-- Lisamisel: 1) lõpetame lapse eelmise rühma (lõpp = päev enne uue algust),
                    2) sama päeva varasem rühma valik asendatakse (parandus),
                    3) lisame uue rea tabelisse Ruhmas_olek,
                    4) märgime lapse järjekorra kirje "vastu võetud". --%>
    <asp:SqlDataSource ID="SqlDataSource1_ruhmas_olek" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT * FROM [Ruhmas_olek]"
        InsertCommand="SET XACT_ABORT ON;
            BEGIN TRY BEGIN TRAN;
            DECLARE @algus date = ISNULL(@alguse_kp, CAST(GETDATE() AS date));
            UPDATE [Ruhmas_olek] SET [lopu_kp] = DATEADD(day, -1, @algus)
                WHERE [laps_id] = @laps_id AND [lopu_kp] IS NULL AND [alguse_kp] BETWEEN '1900-01-01' AND DATEADD(day, -1, @algus);
            DELETE FROM [Ruhmas_olek] WHERE [laps_id] = @laps_id AND [alguse_kp] = @algus;
            INSERT INTO [Ruhmas_olek] ([laps_id], [ruhm_id], [alguse_kp]) VALUES (@laps_id, @ruhm_id, @algus);
            UPDATE [Jarjekord] SET [staatus] = N'vastu võetud'
                WHERE [laps_id] = @laps_id AND [staatus] IN (N'ootel', N'pakutud');
            COMMIT TRAN; END TRY
            BEGIN CATCH IF @@TRANCOUNT != 0 ROLLBACK TRAN; THROW; END CATCH;">
        <InsertParameters>
            <asp:Parameter Name="laps_id" Type="Int32" />
            <asp:Parameter Name="ruhm_id" Type="Int32" />
            <asp:Parameter Name="alguse_kp" Type="DateTime" />
        </InsertParameters>
    </asp:SqlDataSource>

    <p><asp:Label ID="LabelTeade" runat="server" EnableViewState="False"></asp:Label></p>

    <h3>Kõik lapsed</h3>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="laps_id"
        DataSourceID="SqlDataSource1" EmptyDataText="Andmed puuduvad." CssClass="table"
        OnRowDeleted="GridView1_RowDeleted">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemTemplate>
                    <asp:LinkButton ID="LinkButtonDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Kustuta"
                        OnClientClick="return confirm('Kustutada see laps koos tema rühmade, järjekorra ja puudumistega?');"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="laps_id" HeaderText="ID" SortExpression="laps_id" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" />
            <asp:BoundField DataField="synniaeg" HeaderText="Sünniaeg" SortExpression="synniaeg" DataFormatString="{0:dd.MM.yyyy}" />
            <asp:BoundField DataField="vanus" HeaderText="Vanus" SortExpression="vanus" />
            <asp:BoundField DataField="ruhm" HeaderText="Praegune rühm" SortExpression="ruhm" NullDisplayText="pole rühmas" />
            <asp:BoundField DataField="soovitud_ruhm" HeaderText="Soovitud rühm" SortExpression="soovitud_ruhm" NullDisplayText="—" />
            <asp:BoundField DataField="jarjekord" HeaderText="Järjekord" SortExpression="jarjekord" NullDisplayText="—" />
            <asp:BoundField DataField="puudumisi" HeaderText="Puudumisi" SortExpression="puudumisi" />
        </Columns>
    </asp:GridView>

    <%-- Praegune rühm: Ruhmas_olek, kus tänane kuupäev on alguse ja lõpu vahel (kui sellist pole: "pole rühmas").
         Järjekord ja soovitud rühm: viimane kirje tabelist Jarjekord.
         Kustutamisel: enne kustutame lapse kirjed tabelitest Puudumine, Jarjekord ja Ruhmas_olek (võõrvõtmed), siis lapse. --%>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT Laps.laps_id, Laps.eesnimi, Laps.perenimi, Laps.synniaeg, (CONVERT(int, CONVERT(char(8), GETDATE(), 112)) - CONVERT(int, CONVERT(char(8), Laps.synniaeg, 112))) / 10000 AS vanus, praegu.nimetus AS ruhm, jk.staatus AS jarjekord, jk.soovitud_ruhm, (SELECT COUNT(*) FROM Puudumine WHERE Puudumine.laps_id = Laps.laps_id) AS puudumisi FROM Laps OUTER APPLY (SELECT TOP 1 Ruhm.nimetus FROM Ruhmas_olek INNER JOIN Ruhm ON Ruhmas_olek.ruhm_id = Ruhm.ruhm_id WHERE Ruhmas_olek.laps_id = Laps.laps_id AND CAST(GETDATE() AS date) BETWEEN Ruhmas_olek.alguse_kp AND ISNULL(Ruhmas_olek.lopu_kp, '9999-12-31') ORDER BY Ruhmas_olek.alguse_kp DESC) AS praegu OUTER APPLY (SELECT TOP 1 Jarjekord.staatus, Ruhm.nimetus AS soovitud_ruhm FROM Jarjekord LEFT JOIN Ruhm ON Jarjekord.soovitud_ruhm_id = Ruhm.ruhm_id WHERE Jarjekord.laps_id = Laps.laps_id ORDER BY Jarjekord.lisamise_kp DESC, Jarjekord.jarjekord_id DESC) AS jk ORDER BY Laps.perenimi, Laps.eesnimi"
        DeleteCommand="SET XACT_ABORT ON;
            BEGIN TRY BEGIN TRAN;
            DELETE FROM [Puudumine] WHERE [laps_id] = @laps_id;
            DELETE FROM [Jarjekord] WHERE [laps_id] = @laps_id;
            DELETE FROM [Ruhmas_olek] WHERE [laps_id] = @laps_id;
            DELETE FROM [Laps] WHERE [laps_id] = @laps_id;
            COMMIT TRAN; END TRY
            BEGIN CATCH IF @@TRANCOUNT != 0 ROLLBACK TRAN; THROW; END CATCH;">
        <DeleteParameters>
            <asp:Parameter Name="laps_id" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
